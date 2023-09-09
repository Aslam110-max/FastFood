import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
class OrderHelper{
static Future<void> createTables(sql.Database database)async{
  await database.execute("""CREATE TABLE items(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  foodName TEXT NOT NULL,
  hotelName TEXT NOT NULL,
  foodWidth TEXT NOT NULL,
  price DOUBLE NOT NULL,
  foodCount INTEGER NOT NULL,
  foodType TEXT NOT NULL,
  imageUrl TEXT NOT NULL
  )
  """);

}
static Future<sql.Database> db()async{
  return sql.openDatabase(
    'orderss.db',
    version: 1,
    onCreate: (sql.Database database, int version)async{
      print('***************************Creating tables**********************************');
      await createTables(database);
    }
  );
}
static Future<int> createItem(String foodName, String hotelName, String foodWidth, double price,int foodCount,String foodType,String imageUrl)async{
  final db = await OrderHelper.db();
  final data = {'foodName':foodName,'hotelName':hotelName,'foodWidth':foodWidth,'price':price,'foodCount':foodCount,'foodType':foodType,'imageUrl':imageUrl};
  final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  return id;
}
static Future<List<Map<String,dynamic>>> getItems()async{
  final db = await OrderHelper.db();
  return db.query('items',orderBy: "id");
}
static Future<List<Map<String,dynamic>>> getItem(int id)async{
  final db = await OrderHelper.db();
  return db.query('items',where: "id=?",whereArgs: [id],limit: 1);
}
static Future<int> updateItem(
    int id, String foodName,String hotelName,String foodWidth,double price,int foodCount,String foodType,String imageUrl
    )
async {
final db =await  OrderHelper.db();
final data ={
  'foodName':foodName,
  'hotelName':hotelName,
  'foodWidth':foodWidth,
  'price':price,
  'foodCount':foodCount,
  'foodType':foodType


};
final result = await db.update('items', data,where: "id=?",whereArgs: [id]);
return result;
}
static Future<void> deleteItem(int id)async{
  final db = await OrderHelper.db();
  try{
    await db.delete("items",where:"id=?",whereArgs: [id]);
  }catch(e){
    debugPrint("something wrong while delete an item erro:$e");
  }
}
}