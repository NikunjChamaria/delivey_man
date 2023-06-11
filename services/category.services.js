const CategoryModel=require('../model/categories.model');

class CategoryService{
    static async postData(foodType,imageUrl){
        try {
            const data=new CategoryModel({foodType,imageUrl});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=CategoryService;