using MySql.Data.MySqlClient;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Ajax_login_user : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ArrayList TestMethod()
    {
        string name = "not";
        //string Q = "select * from user where template= '" + template + "'";
        
        ArrayList template = new ArrayList();
        int index = 0;
        string Q = "select * from user ";
        MySqlConnection CONN = new MySqlConnection("Database=fingerprint;Data Source=localhost ;User Id=root;Password=");
        CONN.Open();

        //MySqlCommand command = connection.CreateCommand();
        //command.CommandText = "select * from data";
        MySqlCommand CMD = new MySqlCommand(Q, CONN);
        MySqlDataReader reader = CMD.ExecuteReader();


        while (reader.Read())
        {
            ////reader.GetString(0)
            //check = reader["content"].ToString();
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('ok')", true);
            name = reader.GetString(1);
            template.Add(reader.GetString(2));
            // Re    

        }

        return  template;
    }

}