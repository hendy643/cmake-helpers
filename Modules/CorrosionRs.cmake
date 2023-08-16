include_guard(GLOBAL)

include(FetchContent)

FetchContent_Declare(
    Corrosion
    GIT_REPOSITORY https://github.com/corrosion-rs/corrosion.git
    GIT_TAG v0.4 # Optionally specify a commit hash, version tag or branch here
)
FetchContent_MakeAvailable(Corrosion)

# this is how you use it:
# Import targets defined in a package or workspace manifest `Cargo.toml` file
# corrosion_import_crate(MANIFEST_PATH rust-lib/Cargo.toml)
# target_link_libraries(your_cpp_bin PUBLIC rust-lib)