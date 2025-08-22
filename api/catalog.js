const fetch = require("node-fetch");

module.exports = async (req, res) => {
  try {
    const response = await fetch(
      "https://catalog.roblox.com/v1/search/items/details?Category=1&Limit=10"
    );

    if (!response.ok) {
      res.setHeader("Access-Control-Allow-Origin", "*");
      return res
        .status(500)
        .json({ error: `Roblox API error: ${response.status}` });
    }

    const data = await response.json();

    const items = await Promise.all(
      data.data.map(async (item) => {
        let thumbnailUrl = null;

        try {
          if (item.itemType === "Bundle") {
            const thumbRes = await fetch(
              `https://thumbnails.roblox.com/v1/bundles/icons?bundleIds=${item.id}&size=420x420&format=Png`
            );
            const thumbData = await thumbRes.json();
            thumbnailUrl = thumbData.data?.[0]?.imageUrl || null;
          }

          if (item.itemType === "Asset") {
            const thumbRes = await fetch(
              `https://thumbnails.roblox.com/v1/assets?assetIds=${item.id}&size=420x420&format=Png`
            );
            const thumbData = await thumbRes.json();
            thumbnailUrl = thumbData.data?.[0]?.imageUrl || null;
          }
        } catch (err) {
          console.error(`Error obteniendo thumbnail para ${item.id}:`, err);
        }

        return {
          Id: item.id,
          Name: item.name,
          Description: item.description || "",
          ItemType: item.itemType,
          Price: item.price || 0,
          CreatorName: item.creatorName,
          CreatorId: item.creatorTargetId,
          Image: thumbnailUrl,
        };
      })
    );

    res.setHeader("Access-Control-Allow-Origin", "*");
    res.json(items);
  } catch (err) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.status(500).json({ error: err.message });
  }
};
