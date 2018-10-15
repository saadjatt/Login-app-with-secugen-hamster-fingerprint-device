<%@ Page Title="Secugen-Demo1" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="RegisterCode.aspx.cs" Inherits="Demo1" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<!DOCTYPE html>
<html>
<head>
    <title>Demo1</title>
    <style>
        #FPImage1 {
            cursor:pointer;
        }
    </style>
</head>
<body>
          
    <div class="row">
        <h1><b>Register User</b></h1>
        <div class="col-md-10">
          
            <div class="row">
                
                        
                
                        <span class="download_href"> 
                           
                            <img id="FPImage1" alt="Fingerpint Image" height=300 width=210 align="center" src=".\Images\f1.gif" onclick="captureFP()" > <br>

                           Name <input type="text" value="" id="name"  ><br>
                            
                            <input type="button" value="Sign Up Now" onclick="insert_user()" ><br>
                           

                         

                            <br/>
                            <p id="notify"></p>
                        </span>
                       

            </div>
        </div>
    </div>

<script type="text/javascript">
    var template = "";
    var finger = "";
    

    function captureFP() {
    CallSGIFPGetData(SuccessFunc, ErrorFunc);
}

/* 
    This functions is called if the service sucessfully returns some data in JSON object
 */
function SuccessFunc(result) {
    if (result.ErrorCode == 0) {
        /* 	Display BMP data in image tag
            BMP data is in base 64 format 
        */
        if (result != null && result.BMPBase64.length > 0) {
            document.getElementById("FPImage1").src = "data:image/bmp;base64," + result.BMPBase64;
        }
        
        template = result.TemplateBase64;
        //finger = result.BMPBase64;
      
    }
    else {
        alert("Fingerprint Capture Error Code:  " + result.ErrorCode + ".\nDescription:  " + ErrorCodeToString(result.ErrorCode) + ".");
    }


    }

    function insert_user() {
        var name = document.getElementById("name").value;



        
          $.ajax({
      type: "POST",
              url: "Ajax_register_user.aspx/TestMethod",
              data: "{'template': '" + template + "', 'name': '" + name + "'}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function(msg) {
        //$("#Result").text(msg.d);
          //alert(msg.d);
            document.getElementById('notify').innerHTML = 'Inserted';
      }
    });
    }

function ErrorFunc(status) {

    /* 	
        If you reach here, user is probabaly not running the 
        service. Redirect the user to a page where he can download the
        executable and install it. 
    */
    alert("Check if SGIBIOSRV is running; Status = " + status + ":");

}


function CallSGIFPGetData(successCall, failCall) {
    // 8.16.2017 - At this time, only SSL client will be supported.
    var uri = "https://localhost:8443/SGIFPCapture";

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            fpobject = JSON.parse(xmlhttp.responseText);
            successCall(fpobject);
        }
        else if (xmlhttp.status == 404) {
            failCall(xmlhttp.status)
        }
    }
    var params = "Timeout=" + "10000";
    params += "&Quality=" + "50";
    params += "&licstr=" + encodeURIComponent(secugen_lic);
    params += "&templateFormat=" + "ISO";
    console.log
    xmlhttp.open("POST", uri, true);
    xmlhttp.send(params);

    xmlhttp.onerror = function () {
        failCall(xmlhttp.statusText);
    }
}


</script>
</body>
</html>
</asp:Content>