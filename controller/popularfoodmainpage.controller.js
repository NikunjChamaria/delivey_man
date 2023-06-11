const PopularFoodMainPageService=require('../services/popularFoodMain.servies');
const PopularFoodMainPageModel = require('../model/pupularfoodmainpage.model');

exports.upload=async (req,res,next)=>{
    try {
        const {name,imageUrl,rating}=req.body;

        const success=await PopularFoodMainPageService.uploadData(name,imageUrl,rating);

        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.download=async (req,res,next)=>{
    try {
        const result= await PopularFoodMainPageModel.find();
        res.send(result);
    } catch (error) {
        throw(error);
    }
}