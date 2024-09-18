#! /bin/bash
#Author: ibrahim
#Date:18/9/2024
#Desc:Database using bash script

#define database position
DB_pos="./Database"
link_database(){
dbname=$1
  echo "Connected to Database: $dbname"
  echo "1) Create Table"
  echo "2) List Tables"
  echo "3) Drop Table"
  echo "4) Insert into Table"
  echo "5) Select From Table"
  echo "6) Delete From Table"
  echo "7) Update Table"
  echo "8) Back to Main Menu"
  read -p "Select an option: " option
  case $option in
    1) create_table "$dbname" ;;
    2) list_tables "$dbname" ;;
    3) drop_table "$dbname" ;;
    4) insert_into_table "$dbname" ;;
    5) select_from_table "$dbname" ;;
    6) delete_from_table "$dbname" ;;
    7) update_table "$dbname" ;;
    8) main_menu ;;
    *) echo "Invalid option. Try again." ;;
  esac


}
#create table done 
create_table(){
	dbname=$1
read -p "Enter the table name " name
if [[ -f "./$DB_pos/$dbname/$name" ]]
then
	echo "this table $name already exist "
else 
	read -p "Enter the table colomes,such as  id(int), firstname(varchar), ...(don't forget spaces):" coloums
	#this standerd date i will show to instruct user 
	echo $coloums >>./$DB_pos/$dbname/$name.standard
	#this file where the data will store in it 
	touch "./$DB_pos/$dbname/$name.text"
	echo " table $name is created sucessfully "
fi
link_database $dbname
}
##list tables 
list_tables(){
dbname=$1
echo -e  "/*************** Tables in $dbname ************************/"
 ls $DB_pos/$dbname/*.text

link_database $dbname

}
#insert into table 
insert_into_table(){
dbname=$1
values=""
read -p "Enter the name of  table " table
if [[ -f  "./$DB_pos/$dbname/${table}.text" ]]
then
echo "you should follow this standard"
cat ./$DB_pos/$dbname/${table}.standard	
x=$(cat ./$DB_pos/$dbname/${table}.standard|wc -w)
for i in $(seq 1 $x)
do
cat ./$DB_pos/$dbname/${table}.standard|awk -F, '{print $i}'
read -p "Enter the value  please: " var
if [ "$i" -eq 1 ]; then
    values="$var"  # No delimiter for the first value
  else
    values="$values,$var"  # Add a comma for subsequent values
  fi
  echo "All values in one line: $values"
done
echo "${values%,}">>"$DB_pos/$dbname/${table}.text"

echo "Row inserted into $table"
else
	echo "table $name not exist"
fi
link_database $dbname
}
#select from table 
select_from_table(){
dbname=$1
read -p "Enter the name of  table " table
if [[ -f  "./$DB_pos/$dbname/${table}.text" ]]
then
	cat "./$DB_pos/$dbname/${table}.text"

else
        echo "table $name not exist"
fi
link_database $dbname


}
#Delete from DataBase 
delete_from_table(){
dbname=$1
read -p "Enter the name of  table " table
if [[ -f  "./$DB_pos/$dbname/${table}.text" ]]
then
	read -p "Eneter the id of user u want delete (uniq)" id
	sed -i  "/$id/d"  "./$DB_pos/$dbname/${table}.text"
	echo "the user with id:$id is deleted sucessfully"
else
        echo "table $name not exist"
fi
link_database $dbname


}
#update  table  DataBase 
update_table(){
dbname=$1
read -p "Enter the name of  table " table
if [[ -f  "./$DB_pos/$dbname/${table}.text" ]]
then
        read -p "Eneter the id of user u want update (uniq)" id
 	read -p "Enter the old Value " old_value
	read -p "Enter the new Value " new_value
        sed -i  "/$id/s/$old_value/$new_value/g"  "./$DB_pos/$dbname/${table}.text"
        echo "the user with id:$id is updated sucessfully"
else
        echo "table $name not exist"
fi
link_database $dbname


}

################################################ MAIN MENU ##############################################
main_menu(){
echo -e  "**************************\t Main Menu: \t************************************" 
echo 1:Create Database
echo 2:List Databases
echo 3:Connect To Databases
echo 4:Delet Database
echo 5:Exit
read -p    "Enter Your Option : " option 
case $option in 
#evere option will have function call 
1)create_database;;
2)list_database;;
3)connect_database;;
4)delet_database;;
5)exit ;;
*)echo "invalid coice ya bro : try again";;
esac
#create Database 
}
create_database(){
	read -p "Enter the DB name : " DB_name
	if [[ -d "./$DB_pos/$DB_name" ]]
	then 
		echo  " ?? the database $DB_name already exist ?? "
	else
		mkdir  -p "./$DB_pos/$DB_name"
		echo "$DB_name successfully created "
	fi
	main_menu
}
#list all Databases
list_database(){
        echo -e  "\t\t #List of DataBase# \n ";
        ls  "$DB_pos";
        main_menu;
}
#connect database
connect_database(){
read -p  "Eneter the DataBase : " database

if [[ -d "./$DB_pos/$database" ]]
then
	link_database "$database"
else
	echo "the database not exist "
	main_menu
fi	

}
delet_database(){
read -p "Enter the database want to drop:" database
if [[ -d "./$DB_pos/$database" ]]
then
	rm -rf "./$DB_pos/$database"
	echo "Database $database droped sucessfully"
else
	echo "Database $database not found "
fi 
main_menu
}
while true
do
	main_menu
done

