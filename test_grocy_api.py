import os
import httpx
from dotenv import load_dotenv


def main() -> None:
    load_dotenv()
    base_url = os.getenv("GROCY_URL")
    token = os.getenv("GROCY_TOKEN")
    if not base_url or not token:
        print("Missing GROCY_URL or GROCY_TOKEN")
        return
    url = base_url.rstrip("/") + "/objects/products"
    try:
        response = httpx.get(url, headers={"GROCY-API-KEY": token}, timeout=10)
        response.raise_for_status()
    except httpx.HTTPStatusError as exc:
        print(f"HTTP error {exc.response.status_code}: {exc.response.text}")
        return
    except httpx.RequestError as exc:
        print(f"Request error: {exc}")
        return
    products = response.json()
    print(f"Total products: {len(products)}")
    for product in products[:5]:
        print(f"{product.get('id')} - {product.get('name')}")


if __name__ == "__main__":
    main()
