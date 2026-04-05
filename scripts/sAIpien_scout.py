import requests
import json
import os
from datetime import datetime

TAVILY_API_KEY = os.getenv("TAVILY_API_KEY")
S2_API_KEY = "F455njqHn782GbNbGS2RL5ZTUhWINeTj4feaOcmH"

members = [
    "Hossein Rahnama",
    "Alex Pentland",
    "Dava Newman",
    "Kent Larson",
    "Matti Grüner"
]

def get_s2_papers(query):
    url = f"https://api.semanticscholar.org/graph/v1/paper/search?query={query}&limit=5&fields=title,year,abstract,authors&year=2023-2026"
    headers = {"x-api-key": S2_API_KEY}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json().get("data", [])
    return []

print(f"### NICA Research Report: MIT sAIpien (2023-2026) ###\n")

for member in members:
    print(f"--- Researcher: {member} ---")
    papers = get_s2_papers(member)
    if not papers:
        print("No recent papers found via S2. Trying Tavily search...")
        # Fallback to Tavily for very recent or non-indexed news/posts
        tav_url = "https://api.tavily.com/search"
        tav_data = {
            "api_key": TAVILY_API_KEY,
            "query": f"{member} MIT Media Lab research 2024 2025",
            "search_depth": "advanced",
            "max_results": 3
        }
        tav_resp = requests.post(tav_url, json=tav_data)
        if tav_resp.status_code == 200:
            results = tav_resp.json().get("results", [])
            for res in results:
                print(f"[*] {res['title']}\n    Source: {res['url']}\n    Snippet: {res['content'][:200]}...")
    else:
        for p in papers:
            year = p.get('year', 'N/A')
            title = p.get('title', 'N/A')
            abstract = p.get('abstract', 'No abstract available.')
            if abstract:
                abstract = abstract[:300] + "..."
            print(f"[{year}] {title}")
            print(f"    Abstract: {abstract}\n")
    print("\n")
