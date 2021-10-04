#![allow(unused_imports, unused_variables,dead_code)]
use argh::FromArgs;
use std::collections::BTreeMap as Map;
use std::{path::PathBuf, process::Command,fmt::Error};
use serde::{Serialize, Deserialize};
use serde_yaml::{Sequence, Value};
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
#[serde(tag="name")]
struct Module {
    name: String,
    sources: Option<Sequence>,
    #[serde(flatten)]
    other: Map<String, Value>,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(tag="name")]
enum SourceType {
    Dir(Sequence),
}




fn main() -> Result<(), serde_yaml::Error> {
    let flatpak: WalletConfig = serde_yaml::from_str(include_str!("../org.themelio.Wallet.yml"))?;
    let flatpak_local: WalletConfig = serde_yaml::from_str(include_str!("../org.themelio.Wallet-local-dev.yml"))?;

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
    println!("{}", serde_yaml::to_string(&flatpak.modules[0]).unwrap());
    println!("Done");
    Ok(())
}
