from fastapi import FastAPI

app = FastAPI()

@app.get("/product")
def get_product():
    return{"product": ["product1","product2"]}