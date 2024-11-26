#!/usr/bin/env python3
import sys
import json
from duckduckgo_search import DDGS
from transformers import pipeline

def create_response(result):
    response_json = json.dumps(result, ensure_ascii=False, indent=2)
    print(response_json)

def main(search_type):
    query = input("Enter your query: ")

    ddg = DDGS()  # Initialize DDGS instance globally
    model = pipeline('sentiment-analysis', model='./model')
    
    if not query:
        print("Error: Query parameter is required")
        return

    if search_type == 'text':
        results = ddg.text(query, max_results=50)
        if not results:
            print("Error: No results found")
            return
        analyses = model([result['body'] for result in results])
        best_result = max(zip(results, analyses), key=lambda x: x[1]['score'])[0]
        create_response(best_result)
        
    elif search_type == 'images':
        results = ddg.images(query, max_results=50)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'videos':
        results = ddg.videos(query, max_results=50)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'news':
        results = ddg.news(query, max_results=50)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'maps':
        results = ddg.maps(query, max_results=50)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'translate':
        to_lang = input("Enter the target language (default is 'en'): ") or "en"
        try:
            results = ddg.translate(query, to=to_lang)
        except Exception as e:
            print(f"Error: {e}")
            return
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'suggestions':
        results = ddg.suggestions(query)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'answers':
        results = ddg.answers(query)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    elif search_type == 'chat':
        results = ddg.chat(query)
        if not results:
            print("Error: No results found")
            return
        create_response(results)
        
    else:
        print("Error: Unknown search type")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python ddgo.py <search_type>")
        print("Search types: text, images, videos, news, maps, translate, suggestions, answers, chat")
        sys.exit(1)

    search_type = sys.argv[1]
    main(search_type)

