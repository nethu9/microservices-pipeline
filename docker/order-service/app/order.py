from fastapi import FastAPI

app = FastAPI()

@app.get("/order")
def read_order():
    return {"order": ["item1", "item2"]}