use flutter_rust_bridge::SyncReturn;

pub fn do_heavy_work() -> Vec<String> {
    vec![]
}

pub fn do_light_work()->SyncReturn<Vec<String>>{
    SyncReturn(vec![])
}