const db=require('../config/db');
const mongoose=require('mongoose');

const { Schema }=mongoose;

const PastSearchesSchema=new Schema({
    userEmail:String,
    resName:String,
    foodName:{
        type:String,
        
    },
    imageUrl:String
});



const PastSearchModel=db.model('pastSearches',PastSearchesSchema);

module.exports=PastSearchModel;