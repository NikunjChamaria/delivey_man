const db=require('../config/db');
const mongoose=require('mongoose');

const { Schema }=mongoose;


const cartHistorySchema=new Schema({
    userEmail:String,
    restaurant:String,
    items:Map,
    time:String,
    amount:Number,
    price:Array,
    isFav:{
        type:Boolean,
        default:false
    },
    isDelivered:{
        type:Boolean,
        default:false
    }
    
});



const CartHistoryModel=db.model('carthistory',cartHistorySchema);

module.exports=CartHistoryModel;