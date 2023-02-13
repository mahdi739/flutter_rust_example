# flutter_rust_example

This is a fork of [sccheruku](https://github.com/sccheruku)/**[flutter_rust_example](https://github.com/sccheruku/flutter_rust_example)** (with some changes)

The following steps demonstrate how to connect a flutter app to rust using [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge), **but just in case you want to build it for android**

*I'm just sharing my experiance and there could be some mistakes. Please let me know if you found any one.

Necessary packages in dart side (use last versions):
```yaml
dependencies:
  flutter_rust_bridge: ^1.63.1
  freezed_annotation: ^2.0.3
  ffi: ^2.0.1
  
dev_dependencies:
  build_runner: ^2.1.11
  freezed: ^2.0.3+1
  ffigen: ^7.2.5
```

Necessary packages in rust side (use last versions):
```toml
[dependencies]
flutter_rust_bridge = "1.63.1"
```

and these lines should exist in your `Cargo.toml`:
```toml
[lib]
crate-type = ["lib", "cdylib", "staticlib"]
```
where
-   `lib` is required for non-library targets, such as tests and benchmarks
-   `staticlib` is required for iOS
-   `cdylib` for all other platforms
([Source](https://cjycode.com/flutter_rust_bridge/template/tour_native_proj.html?highlight=cdylib#nativenativexcodeproj))


Make sure you have installed cargo-ndk:
```shell
cargo install cargo-ndk
```

Make sure you have LLVM. I installed it with visual studio. I don't know the other ways but in this way you should download Visual Studio Installer from here:
https://visualstudio.microsoft.com/downloads/  
Then select **Desktop development with C++**  
*Probably you'd better make sure these two packages are selected from individual components:*
![[https://github.com/mahdi739/flutter_rust_example/blob/main/Screenshot%202023-02.jpg]]

Now run this command:
```shell
flutter_rust_bridge_codegen --rust-input rust/src/api.rs --dart-output lib/bridge_generated.dart  --llvm-path 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64'
```
`rust-input` refers to the rust file that ypu want to yous its functions in dart  
`dart-output` refers to the dart file that will be generated based on your rust file  
(If you want to have multiple rust files, see [here](https://cjycode.com/flutter_rust_bridge/feature/multiple_files.html))  
`llvm-path` refers to the address of the LLVM in your computer.

then go to your rust directory
```shell
cd rust
```
and run this:
```shell
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../android/app/src/main/jniLibs build --release
```
`-o` refers to the output folder  
`-t` refers to the targets you want to build for.  
*for each target, you should have installed them with rustup first:*
```shell
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android
```

Add this dart code in `main.dart` for example:
```dart
const base = "rust";
final path = Platform.isWindows ? "$base.dll" : "lib$base.so";
late final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(path);
late final api = RustImpl(dylib);
```

## References: 
https://doc.rust-lang.org/std/sync/atomic/struct.AtomicU64.html
http://cjycode.com/flutter_rust_bridge/tutorial_with_flutter.html
https://github.com/Desdaemon/flutter_rust_bridge_template
https://github.com/fzyzcjy/flutter_rust_bridge/tree/master/frb_example/with_flutter
