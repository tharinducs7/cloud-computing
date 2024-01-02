/* eslint-disable jsx-a11y/iframe-has-title */
import React from "react";
import { stackList } from "../../data/ProjectData";
import {
  Image,
  Technologies,
  Tech,
  TechImg,
  TechName,
  ContactWrapper,
} from "./AboutElements";
function About() {
  return (
    <ContactWrapper id="about">
      <div className="Container">
        <div className="SectionTitle">About CCA Developers</div>
        <div className="BigCard">
          <Image
            src="https://raw.githubusercontent.com/gurupawar/website/main/src/Assets/man-svgrepo-com.svg"
            alt="man-svgrepo"
          />
          <div className="AboutBio">
            Welcome to CCA Developers, <strong>Group No. 7, specializing in startic web development and deploy for the MSc in ASE, Cloud Computing Application Subject, Coursework 1 Part B.</strong> As participants in this CCA, our team is committed to showcasing the power and versatility of cloud computing, with a specific focus on Amazon Web Services (AWS).

          </div>
          <div className="AboutBio tagline2">
            As part of our coursework, we are excited to present a project that demonstrates how to host a static React app on an S3 bucket, utilizing Amazon CloudFront for content delivery, and orchestrating the entire process with Terraform. This project serves as a practical illustration of cloud infrastructure as code, automation, and continuous integration and deployment (CI/CD) practices.
          </div>
          <div className="AboutBio">
          <iframe width="560" height="315" src="https://www.youtube.com/embed/BC2oK_S-3GI" frameborder="0" allowfullscreen></iframe>
          </div>
          <Technologies>
            {stackList.map((stack, index) => (
              <Tech key={index} className="tech">
                <TechImg src={stack.img} alt={stack.name} />
                <TechName>{stack.name}</TechName>
              </Tech>
            ))}
          </Technologies>

          <ul style={{ marginTop: "20px"}}>
            <li style={{ marginBottom: "10px"}} ><strong>Static React App Hosting:</strong> <br></br> Explore how we host a static React application, showcasing the capabilities of AWS S3 for scalable and cost-effective hosting.</li>
            <li style={{ marginBottom: "10px"}}><strong>Amazon CloudFront Integration:</strong> <br></br>  Witness the seamless integration of Amazon CloudFront to optimize content delivery, ensuring a fast and reliable user experience globally.</li>
            <li style={{ marginBottom: "10px"}}><strong>Infrastructure as Code with Terraform:</strong> <br></br>  Learn how we use Terraform to define, provision, and manage our AWS infrastructure, providing a repeatable and version-controlled approach to cloud deployment.</li>
            <li style={{ marginBottom: "10px"}}><strong>GitHub CI/CD Actions:</strong> <br></br>  Experience the power of continuous integration and deployment with GitHub Actions, automating the deployment pipeline for our static React app.</li>
          </ul>

          <h2 style={{ marginTop: "20px", fontWeight:"bold", marginBottom: "15px" }}>Project Context</h2>
          <p>
              <strong >Coursework:</strong> <br></br> <span>This project is a part of the MSc program in Cloud Computing Application, specifically Coursework 1 Part B </span>.<br></br><br></br>
              <strong>Group No. 7:</strong> <br></br> As Group No. 7, we collaboratively explore and implement cloud computing concepts to address the requirements of the coursework.
          </p>

         
        </div>
      </div>
    </ContactWrapper>
  );
}

export default About;
