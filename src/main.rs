#![allow(unused_imports, unused_variables, dead_code)]
use argh::FromArgs;
use serde::{de::{Deserializer,value,IntoDeserializer}, Deserialize, Serialize};
use serde_yaml::{Sequence, Value};
use std::str::FromStr;
use std::collections::BTreeMap as Map;
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
#[derive(Debug, Serialize, Deserialize)]
struct Module {
    name: String,
    sources: Option<Vec<ModuleSource>>,
    #[serde(flatten)]
    other: Map<String, Value>,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
#[serde(tag = "type")]
enum ModuleSource {
    Dir { path: String },
    Git { url: String, branch: String },
    File { path: String },
    // #[serde(other)]
    // Other,
}

fn main() -> Result<(), serde_yaml::Error> {
    let flatpak: WalletConfig = serde_yaml::from_str(include_str!("../org.themelio.Wallet.yml"))?;
    let flatpak_local: WalletConfig =
        serde_yaml::from_str(include_str!("../org.themelio.Wallet-local-dev.yml"))?;

    // let flatpak_local = serde_yaml::from_str(include_str!("../org.themelio.Wallet-local-dev.yml"))
    // .expect("Check your yaml file for formatting errors")[0];

    // let mut flatpak_builder = flatpak.as_hash().unwrap().clone();

    // flatpak_builder.clone().into_iter().for_each(|x| {
    //     println!("{:?}", x)
    // });

    // let mut modules = &flatpak_builder[&Yaml::String("modules".into())];
    // modules.as_vec().insert();
    // flatpak_builder.insert(Yaml::String("modules".into()), Yaml::String("modules".into()));
    // let modules = flatpak_builder["modules".into()];

    // println!("{:?}", flatpak_builder[&Yaml::String("modules".into())][0]);
    println!("{:?}", &flatpak.modules[0]);
    println!("Done");
    Ok(())
}
