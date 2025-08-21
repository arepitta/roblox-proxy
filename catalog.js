const fetch = require("node-fetch");

module.exports = async (req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");

  try {
    const response = await fetch(
      "https://catalog.roblox.com/v1/search/items/details?Category=3&Subcategory=3&Limit=10&SortType=3"
    );
    const data = await response.json();
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.toString() });
  }
};
