from fastapi import FastAPI
from pydantic import BaseModel
from helpers import summarizer
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

class Item(BaseModel):
    rawdoc: str 

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/items/")
async def create_item(item: Item):
  try:
    result = summarizer(item.rawdoc)
    num_words_input = len(item.rawdoc.split())
    num_words_summary = len(result.split())
    print(result)
    return {"summary": result,"num_words_input":num_words_input,"num_words_summary":num_words_summary}
  except Exception as e:
        print(item)
        raise HTTPException(status_code=500, detail=str(e))