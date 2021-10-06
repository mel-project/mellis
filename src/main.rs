#![allow(unused_imports, unused_variables, dead_code)]
use argh::FromArgs;
use serde::{
    de::{value, Deserializer, IntoDeserializer},
    Deserialize, Serialize,
};
use serde_yaml::{Sequence, Value};
use std::collections::BTreeMap as Map;
use std::collections::HashSet as Set;
use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};
use std::str::FromStr;
use std::{fmt::Error, path::PathBuf, process::Command};
#[derive(FromArgs)]
/// Specify how to build flatpak
struct Sources {
    /// path to compiled ginkou html
    #[argh(option)]
    html_path: PathBuf,
    /// path to compiled a melwalletd
    #[argh(option)]
    melwalletd_path: PathBuf,
    /// path to compiled a ginkou-loader
    #[argh(option)]
    ginkou_loader_path: PathBuf,
}
#[derive(Debug, Serialize, Deserialize)]
struct WalletConfig {
    modules: Vec<Module>,
    #[serde(flatten)]
    other: Map<String, Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Eq)]
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
fn main() -> Result<(), serde_yaml::Error> {
    let mut flatpak_local: WalletConfig =
        serde_yaml::from_str(include_str!("../org.themelio.Wallet-local-dev.yml"))?;
    let mut flatpak_master: WalletConfig =
        serde_yaml::from_str(include_str!("../org.themelio.Wallet.yml"))?;

    let mut set: Set<Module> = flatpak_master
        .modules
        .into_iter()
        .chain(flatpak_local.modules.into_iter())
        .collect();

    fn calculate_hash<T: Hash>(t: &T) -> u64 {
        let mut s = DefaultHasher::new();
        t.hash(&mut s);
        s.finish()
    }
    let flatpak = WalletConfig {
        modules: vec![],
        other: flatpak_master.other,
    };

    println!(
        "{:?}",
        // calculate_hash(&set.take(&Module{name: "ginkou".into(), sources: None, other: Map::new()})),
        {
            let mut v: Vec<Module> = set.into_iter().collect();

            let a = v[1].clone();
            let b = v[2].clone();
            println!("#####Names: {}, {}#######", a.name, b.name);
            println!("{}", a == b);
            calculate_hash(&a) == calculate_hash(&b)
        }
    );
    // println!("{}", serde_yaml::to_string(&set).unwrap());
    println!("Done");
    Ok(())
}
