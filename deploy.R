library(rsconnect)

rsconnect::setAccountInfo(name='phillybail',
                          token='24E9FAF3A3CF45BC8D5C84F0491D3810',
                          secret='pblyS4x8Unf/IwrKAFVp4MmCcCJmqF/6nXcgDY2Y')

rsconnect::deployApp('./')
