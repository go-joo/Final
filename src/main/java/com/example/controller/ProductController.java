package com.example.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.example.domain.Criteria;
import com.example.domain.MeterialAndProductVO;
import com.example.domain.PageMaker;
import com.example.domain.ProductVO;
import com.example.persistence.ProductDAO;
import com.example.service.ProductService;

@Controller
@RequestMapping("/product/")
public class ProductController {
	@Resource(name="uploadPath")
	String path;
	
	@Autowired
	ProductDAO product_dao;
	
	@Autowired
	ProductService product_service;
	
	
	@RequestMapping("admin_product.json")
	@ResponseBody
	public Map<String, Object> admin_product_list(Criteria cri)throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		cri.setPerPageNum(10);
		PageMaker pm=new PageMaker();
		pm.setCri(cri);
		pm.setTotalCount(product_dao.totalCount(cri));
		map.put("list", product_dao.admin_list(cri));
		map.put("pm", pm);
		map.put("cri", cri);
		return map;
	}

	@RequestMapping("product.json")
	@ResponseBody
	public Map<String, Object> product_list(Criteria cri)throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		cri.setPerPageNum(20);
		PageMaker pm=new PageMaker();
		pm.setCri(cri);
		pm.setTotalCount(product_dao.totalCount(cri));
		map.put("list", product_dao.list(cri));
		map.put("pm", pm);
		map.put("cri", cri);
		return map;
	}
	
	@RequestMapping(value="update",method=RequestMethod.POST)
	public String admin_update(ProductVO vo, MultipartHttpServletRequest multi)throws Exception{
		System.out.println("?????? ????????!!!!!!!!"+vo.toString());
		ProductVO oldVO=product_dao.read(vo.getProduct_id());
		
		//???? ?????? ??????????
		MultipartFile file=multi.getFile("file");
		if(!file.isEmpty()){
			String image=System.currentTimeMillis()+"_"+file.getOriginalFilename();
			file.transferTo(new File(path + "/" + image));
			vo.setProduct_image(image);
			
			//???????????? ?????????? ????
			if(oldVO.getProduct_image()!=null){
				new File(path + "/" + oldVO.getProduct_image()).delete();
			}
		}else{
			vo.setProduct_image(oldVO.getProduct_image());
		}
		
		System.out.println(vo.toString());
		product_service.update(vo);
		return "redirect:/admin/product";
	}
	
	@RequestMapping(value="getAttach",method=RequestMethod.POST)
	@ResponseBody
	public List<String> getAttach(String product_id)throws Exception{
		return product_dao.getDetail_images(product_id);
	}
	
	@RequestMapping("main_product.json")
	@ResponseBody
	public Map<String, Object> main_product_list(Criteria cri) throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		cri.setPerPageNum(8);
		PageMaker pm=new PageMaker();
		pm.setCri(cri);
		pm.setTotalCount(product_dao.totalCount(cri));
		map.put("list", product_dao.main_product_list(cri));
		map.put("pm", pm);
		map.put("cri", cri);
		return map;
	}
	@RequestMapping(value="admin_insert",method=RequestMethod.POST)
	public String admin_product_insert(ProductVO vo,MultipartHttpServletRequest multi)throws Exception{
		//??????????
		MultipartFile file=multi.getFile("file");
		if(!file.isEmpty()){
			String image=System.currentTimeMillis()+"_"+file.getOriginalFilename();
			file.transferTo(new File(path + "/" + image));
			vo.setProduct_image(image);
		}
		product_dao.admin_insert(vo);
		return "redirect:/admin/product";
	}
	@RequestMapping("meterial_list.json")
	@ResponseBody
	public Map<String, Object> meterial_list(String product_id) throws Exception{
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("list", product_dao.meterial_list(product_id));
		return map;
	}
}
