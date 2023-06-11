const db=require('../config/db');
const mongoose=require('mongoose');
const e = require('express');

const { Schema }=mongoose;

const restaurantSchema=new Schema({
    resName:{
        type:String,
        required:true,
    },
    imageUrl:{
        type:String,
        required:true,
    },
    rating:{
        type:Number,
        required:false,
    },
    dist:{
        type:Number,
        required:false,
    },
    comments:Number,
    averagePrice:Number,
    foodType:Array,
    location:String
});



const RestaurantModel=db.model('restaurant',restaurantSchema);

module.exports=RestaurantModel;