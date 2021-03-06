<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js"></script>
   <title>자주하는질문 목록</title>
   <style>
      table{width:100%; margin-top:10px; border-collapse: collapse;border-bottom:solid 1px; font-weight:bold;}
      td{border:solid 1px rgb(200, 200, 200) solid;padding: 10px; text-align: center; font-size:13px;}
      .row:hover{cursor:pointer;}
      .row{border-top:solid 1px rgb(200, 200, 200);}
      .title{border-top:2px solid; text-align: center; background:#fafafa; font-size:15pt;}
      #pagination{text-align: center; margin-top:10px;}
      #pagination a{text-decoration:none; color:#123478;}
      #pagination .active{color:#ccc}
      #review_insert{text-align:right;}
      .tit{font-size:25px; float:left; margin-top:25px; margin-bottom:20px; color:#123478; }
      .titSub{font-size:12px; color:gray; }
      #total{display:none;}
   </style>
</head>
<body>
   <h2 class="tit">
      자주하는질문
      <span class="titSub">고객님들께서 가장 자주하시는 질문을 모두 모았습니다.</span>
   </h2>
   <div id="condition">
      <div>
         <select id="searchType" style="float:right; margin-top:25px;">
            <option value="회원문의">회원문의</option>
            <option value="주문/결제">주문/결제</option>
            <option value="취소">취소/교환/반품</option>
            <option value="배송문의">배송문의</option>
            <option value="쿠폰">쿠폰/적립금</option>
            <option value="서비스">서비스 이용 및 기타</option>
            <option value="선택" selected>전체</option>
         </select>
      </div>
   </div>
   <div id="list">
      <table id="tbl" class="table"></table>
      <script id="temp" type="text/x-handlebars-template">
         <tr class="title">
            <td width=200>번호</td>
            <td width=800>제목</td>   
         </tr>
         {{#each list}}
           <tr class="row">  
            <td class="commonQA_number">{{commonQA_number}}</td>
            <td>{{commonQA_title}}</td>
           </tr>
         <tr class="c_row" style="display:none" commonQA_number={{commonQA_number}}>
                 <td></td>
            <td><textarea rows="10" cols="100" style="border:none;" readonly>{{commonQA_contents}}</textarea></td>
            </tr>
         {{/each}}
      </script>
   </div>
   <div id="pagination"></div>
   <br/>
   <div style="float:right;">
      <input type="text" id="commonQA_keyword" class="text_style" placeholder="검색어"/>
      <input type="button" id="btnSearch" class="btn_style" value="검색"/>
      <span id="total"></span>
   </div>

</body>
<script>
   var page=1;
   //var commonQA_keyword="";
   getList();
   
   $("#commonQA_keyword").on("keydown",function(e){
      if(e.keyCode==13){
            $("#btnSearch").click();
      }
   });
   
   $("#btnSearch").on("click",function(){
      page=1;
      getList();
   });
   
   $("#searchType").on("change", function(){
      page=1; 
      getList();   
   });
   
   
   function getList(){
      var searchType = $("#searchType").val();
      var commonQA_keyword=$("#commonQA_keyword").val();
      $.ajax({
         type:"get",
         url:"/board/commonQA_list.json",
         dataType:"json",
         data:{"page":page,"searchType":searchType,"keyword":commonQA_keyword},
         success:function(data){
            var temp = Handlebars.compile($("#temp").html());
            $("#tbl").html(temp(data));
            $("#total").html("검색수:" + data.pm.totalCount);
            
            //페이징목록출력
            var str="";
            var prev=data.pm.startPage-1;
            var next=data.pm.endPage+1;            

            if(data.pm.prev) str +="<a href='" + prev + "'>◀</a>";
            for(var i=data.pm.startPage;i<=data.pm.endPage; i++){
               if(i==page){
                  str += "<a class='active' href='" + i + "'>&nbsp&nbsp" + i + "&nbsp&nbsp</a> ";
               }else{
                     str += "<a href='" + i + "'>&nbsp&nbsp" + i + "&nbsp&nbsp</a> ";
               }   
            }
            if(data.pm.next) str +="<a href='" + next + "'>▶</a>";
            $("#pagination").html(str);
         }
      });
   };
     
   $("#pagination").on("click","a",function(e){
      e.preventDefault();
      page = $(this).attr("href");
      getList();
   });
   
   //클릭시 하단에 tr 글 출력
   $(".table").on("click",".row",function(){
        var tr = $(this);
       var no = tr.find(".commonQA_number").html();
      $(".c_row").each(function(){
         var commonQA_number = $(this).attr("commonQA_number");
         if(no==commonQA_number){
            if($(this).css("display")=="none"){
               $(this).show();
            }else{
               $(this).hide();
            }
         }else{
            $(this).hide();
         }
      });
   });


</script>
</html>