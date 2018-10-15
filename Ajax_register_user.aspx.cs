using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Ajax_register_user : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    
    [WebMethod]
    public static string TestMethod(string name,string template)
    {
       
        


        string Q = "insert into user (name,template) values ('" + name + "','" + template + "')";
        MySqlConnection CONN = new MySqlConnection("Database=fingerprint;Data Source=localhost ;User Id=root;Password=");
        CONN.Open();

        //MySqlCommand command = connection.CreateCommand();
        //command.CommandText = "select * from data";
        MySqlCommand CMD = new MySqlCommand(Q, CONN);
        int result = CMD.ExecuteNonQuery();

        return "Inserted";

    }
}