const { default: mongoose } = require('mongoose');
const PopularFoodMainPage=require('../model/pupularfoodmainpage.model');
const jwt=require('jsonwebtoken');

class PopularFoodMainPageService{
    static async uploadData(name,imageUrl,rating){
        try {
            const upload=new PopularFoodMainPage({name,imageUrl,rating});
            return await upload.save();
        } catch (error) {
            throw error;
        }
    }
}
module.exports=PopularFoodMainPageService;