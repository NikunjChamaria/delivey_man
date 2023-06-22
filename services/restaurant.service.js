const RestaurantModel=require('../model/restaurant.model');

class RestaurantService{
    static async postData(resName,rating,dist,comments,averagePrice,foodType,location,ownerEmail,businessEmail,address,lat,long){
        try {
            const data=new RestaurantModel({resName,rating,dist,comments,averagePrice,foodType,location,ownerEmail,businessEmail,address,lat,long});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=RestaurantService;