package org.jihyeong.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
   //n개의 튜플이 한번에 출력
   private int pageNum;
   private int amount;
   private String type;
   private String keyword;
   
   public Criteria() {
      this(1,10);
   }
   
   public Criteria(int pageNum, int amount) {
      this.pageNum = pageNum;
      this.amount = amount;
   }
   
   public String[] getTypeArr() {
	   return type==null?new String[] {} : type.split(""); //검색 조건을 배열로 처리함
	   //Title - T , Content - C , Writer - W
   }
   
   public String getListLink() {
	   UriComponentsBuilder builder=UriComponentsBuilder.fromPath("")
			   .queryParam("pageNum", this.getPageNum())
			   .queryParam("amount", this.getAmount())
			   .queryParam("type", this.getType())
			   .queryParam("keyword", this.getKeyword());
	   return builder.toUriString();
   }
}