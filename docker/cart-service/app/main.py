from fastapi import FastAPI

app = FastAPI()

@app.get("/carts")
def read_cart():
    return {"cart": ["item1", "item2"}
