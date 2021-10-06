#![allow(unused_imports, unused_variables, dead_code)]
use argh::FromArgs;
use serde::{
    de::{value, Deserializer, IntoDeserializer},
    Deserialize, Serialize,
};
use serde_yaml::{Sequence, Value};
use std::collections::hash_map::DefaultHasher;
use std::collections::BTreeMap as Map;
use std::collections::HashSet as Set;
use std::fs::File;
use std::hash::{Hash, Hasher};
use std::io::prelude::*;
use std::str::FromStr;
use std::{fmt::Error, path::PathBuf, process::Command};

#[derive(FromArgs)]
/// Specify how to build flatpak
struct Args {
    /// path to compiled ginkou html
    #[argh(switch, short = 'i')]
    install: bool,
    /// path to compiled a melwalletd
    #[argh(option)]
    melwalletd_path: Option<PathBuf>,
    /// path to compiled a ginkou-loader
    #[argh(option)]
    ginkou_loader_path: Option<PathBuf>,
}
#[derive(Debug, Serialize, Deserialize, Clone)]
struct WalletConfig {
    modules: Vec<Module>,
    #[serde(flatten)]
    other: Map<String, Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Module {
    name: String,
    sources: Option<Vec<Map<String, Value>>>,
    #[serde(flatten)]
    other: Map<String, Value>,
}

impl std::hash::Hash for Module {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        println!("{}", self.name);
        self.name.hash(state);
    }
}

fn create_build(config: &WalletConfig, name: PathBuf) {
    let mut file = File::create(name.clone())
        .expect(&*format!("Failed to create file {:?}", name.as_os_str()));

    file.write_all(
        serde_yaml::to_string(config)
            .expect("Unable to parse WalletConfig")
            .as_bytes(),
    )
    .expect(&*format!("Failed to create file {:?}", name));
}

fn main() -> Result<(), serde_yaml::Error> {
    let args: Args = argh::from_env();

    let flatpak_local: WalletConfig =
        serde_yaml::from_str(include_str!("../org.themelio.Wallet-local-dev.yml"))?;

    let flatpak_master: WalletConfig =
        serde_yaml::from_str(include_str!("../org.themelio.Wallet.yml"))?;

    let all_modules: Vec<Module> = flatpak_master
        .clone()
        .modules
        .into_iter()
        .chain(flatpak_local.modules.into_iter())
        .collect();

    let shrunk_modules = {
        let mut map: Map<String, Module> = Map::new();
        all_modules.into_iter().for_each(|module| {
            map.insert(module.name.clone(), module);
        });
        map
    };

    let flatpak = WalletConfig {
        modules: flatpak_master
            .modules
            .into_iter()
            .map(|module| shrunk_modules[&module.name.clone()].clone())
            .collect(),
        other: flatpak_master.other.clone(),
    };

    let flatpak_build_file = "org.themelio.Wallet-build.yml";
    create_build(&flatpak, flatpak_build_file.into());

    let mut flatpak_build = {
        let mut command = Command::new("flatpak-builder");
        command.args(["build", flatpak_build_file,  "--force-clean", "--user"]);
        if args.install { 
            command.arg("--install");
        };
        command.spawn().unwrap()
    };
    flatpak_build.wait().unwrap();
    // println!("{}", String::from_utf8_lossy(&flatpak_build.stdout));
    
    // shrunk_modules.into_iter().for_each(|module| {
    //     println!("{:?}", module.name.clone())
    // });

    println!("{}", serde_yaml::to_string(&flatpak.modules).unwrap());
    println!("Done");
    Ok(())
}
