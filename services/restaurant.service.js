const RestaurantModel=require('../model/restaurant.model');

class RestaurantService{
    static async postData(resName,imageUrl,rating,dist,comments,averagePrice,foodType,location){
        try {
            const data=new RestaurantModel({resName,imageUrl,rating,dist,comments,averagePrice,foodType,location});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=RestaurantService;