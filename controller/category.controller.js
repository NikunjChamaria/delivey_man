const CategoryService=require('../services/category.services');
const CategoryModel=require('../model/categories.model');

exports.postData=async(req,res,next)=>{
    try {
        const {foodType,imageUrl}=req.body;
        const success=await CategoryService.postData(foodType,imageUrl);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getData=async(req,res,next)=>{
    try {
        
        const result=await CategoryModel.find();
        res.send(result);
    } catch (error) {
        throw error;
    }
}