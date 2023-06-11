const db=require('../config/db');
const mongoose=require('mongoose');

const { Schema }=mongoose;


const FoodSchema=new Schema({
    resName:{
        type:String,
    },
    name:String,
    price:Number,
    rating:Number,
    comments:Number,
    imageUrl:String
});



const FoodModel=db.model('food',FoodSchema);

module.exports=FoodModel;