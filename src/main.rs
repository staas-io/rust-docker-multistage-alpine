#[async_std::main]
async fn main() -> tide::Result<()> {
    let address = std::env::var("LISTEN_ADDRESS").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = std::env::var("LISTEN_PORT").expect("LISTEN_PORT env var is required");
    let listen = format!("{}:{}", address, port);

    let mut app = tide::new();

    tide::log::start();

    app.at("/").get(move |_| async { Ok("Hello world!\n") });

    app.listen(listen).await?;

    Ok(())
}
