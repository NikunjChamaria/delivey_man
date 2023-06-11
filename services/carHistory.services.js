const CartHistoryModel=require('../model/cartHistory.model');

class CartHistoryService{
    static async postHistory(userEmail,restaurant,items,time,amount,price){
        try {
            const data=new CartHistoryModel({userEmail,restaurant,items,time,amount,price});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=CartHistoryService;