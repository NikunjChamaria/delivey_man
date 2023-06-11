const PopularFProductMainPageService=require('../services/popularproductmain.servoce');
const PopularProductMainPageModel = require('../model/popularproduct.model');

exports.upload=async (req,res,next)=>{
    try {
        const {name,imageUrl,rating}=req.body;

        const success=await PopularFProductMainPageService.uploadData(name,imageUrl,rating);

        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.download=async (req,res,next)=>{
    try {
        const result= await PopularProductMainPageModel.find();
        res.send(result);
    } catch (error) {
        throw(error);
    }
}