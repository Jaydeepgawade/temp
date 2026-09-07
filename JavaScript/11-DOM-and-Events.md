# 11 - DOM and Events

## English
DOM (Document Object Model) lets JavaScript read and change HTML elements.

### Select Elements
```js
const title = document.getElementById("title");
const btn = document.querySelector("#btn");
```

### Change Content and Style
```js
title.textContent = "Hello JavaScript";
title.style.fontSize = "30px";
```

### Events
```js
btn.addEventListener("click", function () {
  alert("Button clicked");
});
```

Important events: `click`, `input`, `change`, `submit`, `keydown`, `mouseover`.

## मराठी
DOM म्हणजे HTML page ला JavaScript मधून access आणि modify करण्याचा मार्ग. Event म्हणजे user ने click, type, submit अशा action केल्यावर चालणारा code.

## Practice
1. Button click वर heading text change कर.
2. Input मधली value screen वर दाखव.
3. Dark/light toggle बनव.
4. Counter app बनव.
5. Form submit validation कर.
6. List मध्ये नवीन item add कर.
7. Delete button ने item remove कर.
8. Character counter बनव.