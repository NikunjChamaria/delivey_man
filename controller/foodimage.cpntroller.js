const FoodImageModel = require("../model/foodimage.model");


exports.download=async(req,res,nest)=>{
    try {
        const {ownerEmail,resName,foodName}=req.body;
        const result=await FoodImageModel.find({ownerEmail:ownerEmail,resName:resName,foodName:foodName},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}