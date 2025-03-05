from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

def scrape_movie_page(url):
    response = requests.get(url)
    if response.status_code != 200:
        return {"error": "Unable to fetch page"}

    soup = BeautifulSoup(response.text, 'html.parser')

    title = soup.find("h1").text.strip() if soup.find("h1") else "No Title Found"
    imdb = soup.find("span", class_="imdb-rating").text.strip() if soup.find("span", class_="imdb-rating") else "N/A"
    images = [img["src"] for img in soup.find_all("img") if "src" in img.attrs][:6]

    html_output = f"""
    <h2 style='color:yellow;'>{title}</h2>
    <p><b>IMDb Rating:</b> {imdb}</p>
    <h3>Screenshots:</h3>
    {''.join(f'<img src="{img}" width="300"><br>' for img in images)}
    <h3>Download Links:</h3>
    <div class="download-container">
        <a href="#" class="download-btn">Download 480p</a>
        <a href="#" class="download-btn">Download 720p</a>
        <a href="#" class="download-btn">Download 1080p</a>
    </div>
    """

    return {"html": html_output}

@app.route("/scrape", methods=["GET"])
def scrape():
    url = request.args.get("url")
    if not url:
        return jsonify({"error": "No URL provided"}), 400
    return jsonify(scrape_movie_page(url))

if __name__ == "__main__":
    app.run(debug=True)
