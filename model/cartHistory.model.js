const db=require('../config/db');
const mongoose=require('mongoose');

const { Schema }=mongoose;


const cartHistorySchema=new Schema({
    userEmail:String,
    restaurant:String,
    items:Map,
    time:String,
    amount:Number,
    price:Array
    
});



const CartHistoryModel=db.model('carthistory',cartHistorySchema);

module.exports=CartHistoryModel;