'use client'
import Image from 'next/image'
import { useState } from 'react';
import { FieldValues, FormProvider, useFieldArray, useForm, useFormContext } from "react-hook-form";


function MyRadio(
  {displayValue, formValue, register,  ...rest}: 
  {displayValue: string, formValue: string, register:any}
  ) {

  return <div>
    <input type="radio" value={formValue} {...register} {...rest} />
    {displayValue} 
  </div>
} // end MyRadio


function handleError(error: any) {
  console.log("error")
  console.log(error)
} // end handleError


function FieldArray({fieldName}:{fieldName: string}) {
  const { control, register } = useFormContext();
  const { fields, append, prepend, remove, swap, move, insert } = useFieldArray({
    control, // control props comes from useForm (optional: if you are using FormContext)
    name: fieldName, // unique name for your Field Array
  });

  return (<div className='flex flex-col'>
    {fields.map((field: any, index: any) => {
      return (
        <div
          className='flex flex-row'
          key={field.id} // important to include key with field's id
        >
          <input
            type="file"
            {...register(`${fieldName}.${index}.value`)} 
          />
          <button onClick={() => {remove(index)}} type="button">Remove</button>
        </div>

      ) // end return
    }) // end map
    }
    <button onClick={() => {append("")}} type="button">Add</button>
    </div>
  );
} // end FieldArray

export default function HomePage() {
  const [output, changeOutput] = useState("")

  function handleSubmission(value: FieldValues) {
    // asp files
    const ASPFiles = value.asp;
    // ontologies files
    const files = value.file;
    // solver to use
    const solver = value.solver;

    // setting form data 
    const formData = new FormData();

    // set asp files
    for (let i = 0; i < ASPFiles.length; ++i) {
      const temp = ASPFiles[i].value[0];
      formData.append(`asp${i}`, temp);
    } // end for i

    // set ontologies 
    for (let i = 0; i < files.length; ++i) {
      const temp = files[i].value[0];
      formData.append(`onto${i}`, temp);
    } // end for i

    // set solver
    formData.append("solver", solver);

    // submit the data
    fetch('http://localhost:9000/reasoning', {
      method: 'POST',
      body: formData
    }) // end fetch
    .then(response => {
      if (response.ok) {
        return response.text();
      } else {
        throw new Error('File upload failed');
      } // end else
    }) // end then
    .then(data => {
      changeOutput(data)
      console.log('Server response:', data);
    }) // end then
    .catch(error => {
      console.error('Error uploading file:', error);
    }); // end catch

  } // end handleSubmission

  const methods = useForm({defaultValues: {
    ASPFile: '',
    solver: "3",
    file: []
  }});
  const { register, handleSubmit } = methods;

  return (<div>
    <FormProvider {...methods}>
      <form onSubmit={handleSubmit(handleSubmission, handleError)} className='flex flex-col'>
        <label htmlFor='asp'>ASP Files:</label>
        <div id="asp">
        {/* <input id="asp" type="file"  {...register('ASPFile', {required: "need to have asp file name"})} /> */}
          <FieldArray fieldName="asp"/>
        </div>

        <label htmlFor='ontologies_list'>Ontologies:</label>
        <div id="ontologies_list">
          <FieldArray fieldName="file"/>
        </div>

        <label htmlFor='solver_selection'>Solvers:</label>
        <MyRadio displayValue="Clingo" formValue="3" register={register("solver")} 
          {...{
            id: "solver_selection"
          }}
        />
        <MyRadio displayValue="DLV" formValue="4" register={register("solver")}
          {...{
            id: 'solver_selection'
          }}
        />
        <button type="submit">Query</button>
      </form>
    </FormProvider>


    <div>
      Output:
      {output}
    </div>
  </div>
  )
}
