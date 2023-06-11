const { default: mongoose } = require('mongoose');
const PopularProductMainPage=require('../model/popularproduct.model');
const jwt=require('jsonwebtoken');

class PopularProductMainPageService{
    static async uploadData(name,imageUrl,rating){
        try {
            const upload=new PopularProductMainPage({name,imageUrl,rating});
            return await upload.save();
        } catch (error) {
            throw error;
        }
    }
}
module.exports=PopularProductMainPageService;