const express = require('express');
const app = express();

// Default Port for Elastic Beanstalk Node.js applications is 8080
// Which is written to the environment variable PORT
const PORT = process.env.PORT || 5000;

app.get('/', (req, res) => {
  res.send('Hello Elastic Beanstalk!');
});

app.listen(PORT, () => {
  console.log(`Server is running on Port: ${PORT}`);
});

// Instructions to create a zip file for deployment
// 1. npm install
// 2. sudo apt update
// 3. sudo apt install zip
// 4. zip -r haider-eb-nodejs.zip *