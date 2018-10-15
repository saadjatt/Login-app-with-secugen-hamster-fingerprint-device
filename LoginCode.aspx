<%@ Page Title="Secugen-Demo3" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="LoginCode.aspx.cs" Inherits="Demo3" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


<!DOCTYPE html>

<html>
<head>
    <title>Demo3</title>
    <style>
        #FPImage1 {
            cursor:pointer;
        }
    </style>


</head>
<body>
    <div class="row">
        <h3><b>Login</b></h3>
        <div class="col-md-10">
                <img border="2" id="FPImage1" alt="Fingerpint Image" height=200 width=160 src=".\Images\f1.gif" onclick="CallSGIFPGetData(SuccessFunc1, ErrorFunc)" > 	    
           <br />
                
            <input type="button" value="Login" onclick="matchScore(succMatch, failureFunc)"> <br><br>
   
            <input type="button" value="Sign Up" onclick="signup()" > <br><br>
            <p id="notify" ></p>
          
           
        </div>
    </div>
</body>
<script type="text/javascript">
    var template_1 = "";
    var template_2 = new Array();
    var finger1 = "";
    var finger2 = "";


    function chk_login() {
        login_success = false;
        
          $.ajax({
      type: "POST",
              url: "Ajax_login_user.aspx/TestMethod",
              data: "{'template': '" + template_1 + "'}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function(msg) {
        //$("#Result").text(msg.d);
          
          template_2 = msg.d;
          
      }
    });
    }

    function signup() {

        window.location.assign("RegisterCode.aspx");
    }


    function SuccessFunc1(result) {
        if (result.ErrorCode == 0) {
            /* 	Display BMP data in image tag
                BMP data is in base 64 format 
            */
            if (result != null && result.BMPBase64.length > 0) {
                //image show
                document.getElementById('FPImage1').src = "data:image/bmp;base64," + result.BMPBase64;
                finger1 = result.BMPBase64;

                
            }
            template_1 = result.TemplateBase64;
            //getFingerTemplate();
            

        }
        else {
            alert("Fingerprint Capture Error Code:  " + result.ErrorCode + ".\nDescription:  " + ErrorCodeToString(result.ErrorCode) + ".");
        }
    }


    

    function ErrorFunc(status) {
        /* 	
            If you reach here, user is probabaly not running the 
            service. Redirect the user to a page where he can download the
            executable and install it. 
        */
        alert("Check if SGIBIOSRV is running; status = " + status + ":");
    }


    function CallSGIFPGetData(successCall, failCall) {
        document.getElementById('notify').innerHTML = "";

        var uri = "https://localhost:8443/SGIFPCapture";
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                fpobject = JSON.parse(xmlhttp.responseText);

                
                document.getElementById('notify').innerHTML = "Checking...";
                
                successCall(fpobject);
               // alert(xmlhttp.responseText);
              //  document.getElementById('result').innerHTML = xmlhttp.responseText;
                chk_login();
                
            }
            else if (xmlhttp.status == 404) {
                failCall(xmlhttp.status)
            }
        }
        xmlhttp.onerror = function () {
            failCall(xmlhttp.status);
        }
        var params = "Timeout=" + "10000";
        params += "&Quality=" + "50";
        params += "&licstr=" + encodeURIComponent(secugen_lic);
        params += "&templateFormat=" + "ISO";
        xmlhttp.open("POST", uri, true);
        xmlhttp.send(params);
         //getFingerTemplate();
    }

   

    
    var login_success = false;

    function matchScore(succFunction, failFunction) {
         

     //   getFingerTemplate();

          
        if (template_1 == "" ) {
            alert("Please scan  finger to verify!!");
            return;
        }
        if (template_2 == "") {
          alert("Please scan  finger to verify!!");
            return;
        }
        
        var uri = "https://localhost:8443/SGIMatchScore";

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                fpobject = JSON.parse(xmlhttp.responseText);
                succFunction(fpobject);
            }
            else if (xmlhttp.status == 404) {
                failFunction(xmlhttp.status)
            }
        }

        xmlhttp.onerror = function () {
            failFunction(xmlhttp.status);
        }

        for (i = 0; i < template_2.length; i++) {
            if (login_success == false) {
                var params = "template1=" + encodeURIComponent(template_1);
                params += "&template2=" + encodeURIComponent(template_2[i]);
                params += "&licstr=" + encodeURIComponent(secugen_lic);
                params += "&templateFormat=" + "ISO";
                xmlhttp.open("POST", uri, false);

                xmlhttp.send(params);
                //  alert(params);
                      

            }
            if (i == (template_2.length - 1)) {
                document.getElementById('notify').innerHTML = "Login Failed" + i;

            }
           
            
           

            
            

        }
    }

    function succMatch(result) {
        var idQuality = 100;
        if (result.ErrorCode == 0) {
            if (result.MatchingScore >= idQuality) {
                //   alert("MATCHED ! (" + result.MatchingScore + ")");

                login_success = true;
                      document.getElementById('notify').innerHTML = "";
                document.getElementById('notify').innerHTML = "Login Success";
                //login success page
                window.location.assign("RegisterCode.aspx");
            }
            else { } 
                //alert("NOT MATCHED ! (" + result.MatchingScore + ")");
                

            
        }
        else {
            alert("Error Scanning Fingerprint ErrorCode = " + result.ErrorCode);
        }
    }

    function failureFunc(error) {
        alert ("On Match Process, failure has been called");
    }

</script>
</html>
</asp:Content>
