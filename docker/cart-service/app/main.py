from fastapi import FastAPI

app = FastAPI()

@app.get("/cart")
def read_cart():
    return {"cart": ["item1", "item2"]}
