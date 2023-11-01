# Menu Title: Redactions to shared highlight
# Needs Case: true
# Needs Selected Items: false
# Version 1.0


highlightMarkupName="highlight"
$highlightMarkup=$currentCase.getMarkupSets().select{|markup|markup.getName()==highlightMarkupName}.first()


if($highlightMarkup.nil?)
  raise Exception.new("Highlight markup not found (must match exactly:'#{highlightMarkupName}'")
end


$markupSets=$currentCase.getMarkupSets()
markedupItems=$currentCase.searchUnsorted('markup-set:("' + $markupSets.join('" OR "') +'")')
total=markedupItems.size
markedupItems.each_with_index do | markedupItem,index |
  if(index % 1000 == 0) 
    puts "#{(index*100.0/total).round(2)} % #{index}/#{total} items"
  end
  markedupItem.getPrintedImage().getPages().each do | myPrintedPage |
    #clearing highlights...
    myPrintedPage.getMarkups($highlightMarkup).each do | markupArea |
      if(markupArea.isHighlight())
        myPrintedPage.remove($highlightMarkup,markupArea)
      end
    end
    #supplimenting with new Highlights
    $markupSets.each do | markupSet |
      myPrintedPage.getMarkups(markupSet).each do | markupArea |
        if(markupArea.isRedaction())
          myPrintedPage.createHighlight($highlightMarkup,markupArea.getX(),markupArea.getY(),markupArea.getWidth(),markupArea.getHeight())
        end
      end
    end
  end
end
puts "100.00 % #{total}/#{total} items"