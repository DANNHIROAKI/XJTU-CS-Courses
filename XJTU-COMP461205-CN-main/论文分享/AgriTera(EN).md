## 1. Developments and challenges in fruit quality testing

Fruit quality testing has become a central issue in the agriculture and food industries as a result of globalization and consumers' increasing desire for healthier foods. Whether it is the fruit farmer, the distributor, the retailer or the final consumer, it is important for them to know exactly the ripeness and quality of the fruit. This is not only about economic benefits, such as avoiding unnecessary food waste and increasing market value, but also about people's health and safety. However, it has been a technological challenge to assess the quality of fruits efficiently, accurately and non-destructively.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015130127455.png" alt="image-20231015130127455" style="zoom:20%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015130154639.png" alt="image-20231015130154639" style="zoom:20%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015130444017.png" alt="image-20231015130444017" style="zoom:20%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015130609638.png" alt="image-20231015130609638" style="zoom:20%;" />

Traditional fruit testing methods, such as terahertz spectroscopy and the use of dielectric constant and refractive index to analyze nutrient content, provide a wealth of information, but they are often destructive and require sampling or slicing, which not only increases food waste, but also restricts the potential for large-scale application. In addition, certain techniques such as near-infrared spectroscopy, although accurate, require direct contact with fruits, which may trigger contamination, while their application is limited.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015131250547.png" alt="image-20231015131250547" style="zoom:20%;" />  <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015131603184.png" alt="image-20231015131603184" style="zoom:20%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015131640927.png" alt="image-20231015131640927" style="zoom:20%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015131751067.png" alt="image-20231015131751067" style="zoom:20%;" /> 

In recent years, with the development of technology, wireless signaling technology has been widely used in food quality testing. Early studies utilizing the low-frequency WiFi and millimeter-wave bands can extract key features of fruits. However, due to their low bandwidth and resolution, they often provide only a rough assessment of fruit ripeness. In contrast, the sub-terahertz (sub-THz) band shows great potential for fruit sensing. Not only does it provide more information deep inside the fruit, it also avoids damage and contamination by eliminating the need for direct contact with the fruit.

:page_facing_up:Advantages of sub-terahertz

> The sub-Terahertz (sub-THz) band excels in fruit quality detection because of its large bandwidth, millimeter penetration depth and high sensitivity to moisture. Compared to WiFi and millimeter waves, it can probe deeper inside the fruit and transmit more information, while compared to near-infrared (NIR) spectroscopy, it has similar accuracy but without the need for direct contact with the fruit and with less propagation loss. In particular, sub-terahertz matches the resonance frequency of water molecules, making it ideal for measuring water inside fruit and assessing its quality.

## 2. AgriTera Technology Overview

In order to solve this problem, scholars from Princeton University and Massachusetts Institute of Technology (MIT) have developed a set of automated, non-invasive, accurate, and scalable fruit quality sensing technologies, called AgriTera, which combines the latest research in the field.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015125229212.png" alt="image-20231015125229212" style="zoom: 50%;" />

#### 2.1. Basic principle and working method

**The basis and core of the AgriTera technology lies in the detection of the reflective characteristics of fruits in the sub-THz frequency band**. These signatures are influenced by the internal chemistry of the fruit, such as moisture changes associated with the ripening process. This means that it is feasible to map specific ripeness signatures in the reflectance spectrum to known ripeness indicators such as dry matter and Brix values. To achieve this, AgriTera focuses on describing the relationship between the spectrum of a fruit's reflectance signal and its electromagnetic properties over time, allowing AgriTera to predict fruit quality by analyzing the spectral characteristics of sub-THz signals alone

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015132316798.png" alt="image-20231015132316798" style="zoom:33%;" /> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015132351922.png" alt="image-20231015132351922" style="zoom:33%;" /> 

#### 2.2. **Characterization of fruit mass on reflected sub-terahertz signals**

To gain a deeper understanding of how fruits interact with electromagnetic waves in the sub-THz band, we need to consider the physical and biochemical structure of fruits. Fruit is a multilayered structure, with each layer having its own unique dielectric constant and magnetic permeability, which determine the refractive index of each layer. These refractive indices change in response to chemical and biochemical changes in the fruit during ripening, which affects the way electromagnetic waves interact with the fruit.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231014233607764.png" alt="image-20231014233607764" style="zoom: 33%;" />  

AgriTera technology relies heavily on the spectral signature of reflected signals to sense fruit ripeness. As these signals penetrate the different layers of the fruit, they are attenuated to varying degrees, creating a unique reflectance spectral pattern. This pattern provides AgriTera with critical information about the quality of the fruit.

#### 2.3. Chemometrics analysis on maturity prediction and inference

At the heart of AgriTera's technology is the accurate mapping of sub-terahertz spectral features to key indicators of fruit quality, such as Brix value and dry matter content. To accomplish this, AgriTera employs a partial least squares regression (PLS) model. This model extracts spectral information that is highly correlated with fruit quality, thus providing a powerful tool for accurate fruit quality prediction.

:pager:The description of the PLS model in question is:

> <img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015004533142.png" alt="image-20231015004533142" style="zoom: 30%;" /> 
> 
> 1. **Training Data**: Training is performed using fruit spectral signatures (i.e. Fruit Spectral Signatures) and reference data (e.g. Brix and Dry Matter values).
> 2. **PLSR Component Search**: In this phase, AgriTera searches for PLSR components that are highly correlated with ripeness metrics and finds their corresponding scores. This part involves principal component analysis of the input data and attempts to correlate it with Brix and DM values.
> 3. **Optimizing Correlation Matrix R**: In this step, the system tries to optimize the R matrix, which describes the correlation between PLSR components and Brix and DM values.
> 4. **Prediction from model**: using the previous analysis and training, the model can predict the values of Brix and Dry Matter. By using the prediction model, the measured spectra can be mapped to the predicted Brix and Dry Matter values.
> 
> The PLSR (Partial Least Squares Regression) model used by AgriTera effectively maps spectral data to Brix and Dry Matter values. This is because PLSR does not just look at the major variations in the spectral data, but also focuses on information that is highly correlated with the Brix and Dry Matter readings.

## 3. Experimental implementation

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015010402690.png" alt="image-20231015010402690" style="zoom:50%;" /> 

To evaluate the performance of AgriTera, the research team conducted a series of aerial experiments. The centerpiece of the experimental setup was a Styrofoam platform simulating a conveyor belt on which various fruits were placed, while the transmitter and receiver were positioned underneath it, taking advantage of the foam's low absorption properties. A TeraMetrix T-Ray time-domain broadband system was used to handle signal transmission and reception, capable of providing a stable frequency response in the 100 GHz to 400 GHz range. Thirty fruits were considered in the study, including green apples, avocados and persimmons, with each fruit measured every 12 hours for 10 days. To ensure accuracy, the research team also used specialized Brix and dry matter measurement tools and established a baseline protocol based on image processing for control.

## 4. **Evaluation and application of AgriTera technology in fruit ripeness detection**

**1. Initial feasibility experiments:** The core concept of AgriTera is to utilize the features produced in the spectral profile of the sub-THz signal by chemical interactions in the pulp. In experiments on persimmons, the reflected power decreases over time, which is associated with the persimmon losing moisture and becoming more transparent to the sub-THz signal. This spectral change occurs over a wide frequency range, suggesting that the frequency is sensitive to fruit ripening and chemical changes.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015090401026.png" alt="image-20231015090401026" style="zoom:50%;" /> 

**2. Changes in dry matter and Brix:** By monitoring persimmons, green apples and avocados over a period of 10 days, it was found that the conversion of starch to sugar in the fruits increased the Brix value over time. The Brix or dry matter values of each fruit stabilized after reaching a steady point. By measuring these values directly or indirectly, it is possible to get an overall picture of the quality of the fruit.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015091309171.png" alt="image-20231015091309171" style="zoom:50%;" /> 

**3. Fruit-specific spectral characteristics:** The contribution of frequency to the quality of prediction was investigated using the PLSR model. The results show that each fruit has its unique frequency characteristics and a uniform coefficient matrix cannot be used for all fruits. For estimating fruit ripeness, broadband wireless transmission techniques are required.

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015092239290.png" alt="image-20231015092239290" style="zoom: 50%;" /> 

**4. Ripeness estimation performance:** AgriTera was able to accurately map spectral features to Brix and Dry Matter estimates. Compared to image data captured by RGB cameras, AgriTera performs better in assessing fruit quality, as image-based methods have a slow process of change over a 10-day period that lacks detail.

<img src="C:\Users\。\AppData\Roaming\Typora\typora-user-images\image-20231015093546591.png" alt="image-20231015093546591" style="zoom:50%;" /> 

**5. Post-ripening inferences:** Unlike traditional assessment methods, AgriTera is able to provide inferences about fruit quality at the overripe stage. Using the attenuation values of the sub-THz reflected energy, it is possible to assess the state of overripeness or decay of certain fruits even if their Brix and dry matter values stabilize over time

<img src="https://raw.githubusercontent.com/DANNHIROAKI/PicGo-Typora-GitHub-Picture-bed/main/img/image-20231015093859178.png" alt="image-20231015093859178" style="zoom:50%;" /> 

### 6. Future work and conclusions

As technology advances, AgriTera technology opens up a whole new avenue for non-destructive, non-contact fruit quality inspection. However, as with any new technology, we believe that this technology as currently proposed faces a number of unresolved issues and challenges.

:+1:Mentioned in the text + our proposed solution

> :one:Peel texture poses a problem for AgriTera. Fruits with rough surfaces such as avocados and kiwis may result in reduced reflected power and increased estimation error.
>
> OUR SOLUTION: Research and develop a compensation algorithm that adjusts and optimizes signal processing according to the skin texture characteristics of different fruits. At the same time, with a large amount of sample data, we can train machine learning models to predict and compensate for such errors, thus improving the accuracy of ripening.
>
> :two: Investigating how the peel affects ripeness determination. Considering that smartphones may have high-frequency transmission capabilities in the future, AgriTera has great potential for use in mobile devices, but also faces challenges, such as signal fluctuations.
>
> Our solution: design an adaptive signal processing mechanism which monitors and adjusts the quality of signal reception in real time. In addition, combining existing sensor technologies, such as gyroscopes and accelerometers, can further optimize and correct the signal to provide a more stable output.
>
> :three: In addition, AgriTera has promising applications in food safety and wine detection, such as detecting food foreign bodies and monitoring wine fermentation.
>
> Our solution:Specific algorithmic models can be further researched and developed to distinguish food foreign bodies from normal tissues. For wine fermentation detection, the quality and maturity of the wine can be determined by monitoring the changes of chemicals in the wine, which combined with AgriTera's high frequency sensing technology provides more accurate and timely results.

:yellow_heart:Challenges and room for improvement that we believe may still exist

> :one:
>
> - **Problem description**: AgriTera may work best in certain environments and temperatures, but its performance may suffer under different climatic, humidity or temperature conditions.
> - **Direction for Improvement**: Develop a more robust algorithm or system design that allows AgriTera to maintain high accuracy and stability across a wide range of environmental conditions. This may involve extensive field testing under different environmental conditions, as well as using machine learning methods to train on data from different environments to make the system more environmentally adaptable.
>
> :two:
>
> - **Problem description**: Different users may have different standards and expectations for fruit ripeness and quality. The current AgriTera system may provide a one-size-fits-all solution that may not meet the needs of all users.
> - **Direction for improvement**: Develop a feature that can be personalized according to the specific needs and preferences of the user. For example, some users may prefer slightly raw bananas, while others may prefer fully ripe bananas. Through an interactive user interface, users can set their own ripeness criteria, and AgriTera can then provide customized feedback and suggestions to users based on these criteria.

In summary, AgriTera technology revolutionizes fruit and produce quality testing. Our evaluations have shown that the technology is capable of predicting the quality of different types of fruit with high accuracy, regardless of their shape, structure or orientation. We expect that as our research progresses, AgriTera will be able to provide the public with more food and product safety solutions, further advancing agriculture and food technology.

