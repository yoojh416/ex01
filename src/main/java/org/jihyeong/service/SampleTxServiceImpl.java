package org.jihyeong.service;

import org.jihyeong.mapper.Sample1Mapper;
import org.jihyeong.mapper.Sample2Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class SampleTxServiceImpl implements SampleTxService{
	@Setter(onMethod_ = {@Autowired})
	private Sample1Mapper mapper1;
	@Setter(onMethod_ = {@Autowired})
	private Sample2Mapper mapper2;
	
	@Transactional //Insert가 둘 다 이루어지지 않음 -> 오류가 발생 시 원상복귀 시켜주는 역할
	@Override
	public void addData(String value) {
		log.info("mapper1..........");
		mapper1.insertCol1(value);
		log.info("mapper2..........");
		mapper2.insertCol2(value);
		log.info("end..............");
	}
}
