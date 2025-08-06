const express = require('express');
const app = express();

const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => {
  res.send('Hello AWS EC2 from Jenkins!');
});

app.listen(PORT, () => {
  console.log(`Server is running on Port: ${PORT}`);
});