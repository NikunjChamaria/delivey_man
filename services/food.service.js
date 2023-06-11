
const FoodModel=require('../model/food.model');

class FoodService{
    static async postFoodData(resName,name,price,rating,comments,imageUrl){
        try {
            const data=new FoodModel({resName,name,price,rating,comments,imageUrl});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=FoodService;