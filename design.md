# API

```js
let sabizan = require('sabizan');
sabizan.get('/items/:id', (req, id) => {
  return Item.find(id);
});

sabizan.post('/items/:id', (req, id) => {
  return Item.save(id, req.body);
});
```
