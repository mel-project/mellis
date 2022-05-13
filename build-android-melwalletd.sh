#!/bin/sh

mkdir -p mellis-android/app/src/main/jniLibs/arm64-v8a/
mkdir -p mellis-android/app/src/main/jniLibs/x86_64/
mkdir -p mellis-android/app/src/main/jniLibs/armeabi-v7a/
mkdir -p mellis-android/app/src/main/jniLibs/x86/

cd melwalletd
cross build --release --locked --target aarch64-linux-android
cross build --release --locked --target x86_64-linux-android
cross build --release --locked --target armv7-linux-androideabi
cross build --release --locked --target i686-linux-android
cd ../
cp melwalletd/target/aarch64-linux-android/release/melwalletd mellis-android/app/src/main/jniLibs/arm64-v8a/libmelwalletd.so
cp melwalletd/target/x86_64-linux-android/release/melwalletd mellis-android/app/src/main/jniLibs/x86_64/libmelwalletd.so
cp melwalletd/target/armv7-linux-androideabi/release/melwalletd mellis-android/app/src/main/jniLibs/armeabi-v7a/libmelwalletd.so
cp melwalletd/target/i686-linux-android/release/melwalletd mellis-android/app/src/main/jniLibs/x86/libmelwalletd.so