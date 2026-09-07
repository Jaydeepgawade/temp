# 15 - Fetch API, JSON and Browser Storage

## English
### JSON
JSON is a text format commonly used to exchange data between frontend and backend.

```js
const user = { name: "Jaydeep", age: 25 };
const json = JSON.stringify(user);
const obj = JSON.parse(json);
```

### Fetch API
```js
async function getUsers() {
  const response = await fetch("https://jsonplaceholder.typicode.com/users");
  if (!response.ok) throw new Error("Request failed");
  const data = await response.json();
  console.log(data);
}
```

### Local Storage
```js
localStorage.setItem("name", "Jaydeep");
console.log(localStorage.getItem("name"));
localStorage.removeItem("name");
```

### Session Storage
Works like localStorage but data is normally kept for the current browser tab/session.

## मराठी
JSON API मध्ये data पाठवण्यासाठी/घेण्यासाठी वापरला जातो. Fetch API ने HTTP request करता येतो. Local Storage browser मध्ये data save ठेवतो, तर Session Storage session/tabपुरता data ठेवण्यासाठी उपयोगी आहे.

## Practice
1. Object JSON string मध्ये convert कर.
2. JSON string पुन्हा object मध्ये convert कर.
3. Public API मधून users fetch कर.
4. API result HTML table मध्ये दाखव.
5. API loading/error state दाखव.
6. Name localStorage मध्ये save आणि read कर.
7. Todo list localStorage मध्ये persist कर.
8. Search/filter API data implement कर.